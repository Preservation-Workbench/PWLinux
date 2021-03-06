#!/usr/bin/python3

# Based on https://github.com/derkomai/alfred

import sys

# Check Python version:
if sys.version_info[0] < 3:
    print('You have invoked PWLinux installer with Python 2. PWLinux installer must be run with Python 3.')
    sys.exit()
else:
    import os
    import subprocess
    import urllib.request
    import json
    import pathlib
    import re
    from datetime import datetime
    import time


class Cmd:

    def __init__(self, cmdArgs, stdin=None):
        self.cmd = ' '.join(cmdArgs)
        self.cmdArgs = cmdArgs
        self.stdin = stdin
        self.stdout = None
        self.stderr = None
        self.returncode = None
        self.succeeded = None

        if stdin and type(stdin) is str:
            if stdin[-1] == '\n':
                self.stdin = str.encode(stdin[:-1])
            else:
                self.stdin = str.encode(stdin)


def runCmd(cmdArgs, stdin=None, piped=False):
    if len(cmdArgs) == 1 and '|' in cmdArgs[0]:
        args = [ i.strip().split(' ') for i in cmdArgs[0].split('|') ]
        return runCmd(args, piped=True)

    if piped:
        if len(cmdArgs) > 2:
            return runCmd(cmdArgs[-1], stdin=runCmd(cmdArgs[:-1], piped=True).stdout)
        elif len(cmdArgs) == 2:
            return runCmd(cmdArgs[1], stdin=runCmd(cmdArgs[0], piped=False).stdout)

    cmd = Cmd(cmdArgs, stdin)

    try:
        if cmd.stdin:
            if sys.version_info[1] < 7: # Add capture_output for Python version 3.7 or greater
                result = subprocess.run(cmd.cmdArgs,
                                        input=cmd.stdin,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        #timeout=600,
                                        check=True)
            else:
                result = subprocess.run(cmd.cmdArgs,
                                        input=cmd.stdin,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        capture_output=False, # python >= 3.7
                                        #timeout=600,
                                        check=True)

        else:
            if sys.version_info[1] < 7:
                result = subprocess.run(cmd.cmdArgs,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        #timeout=600,
                                        check=True)
            else:
                result = subprocess.run(cmd.cmdArgs,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        capture_output=False, # python >= 3.7
                                        #timeout=600,
                                        check=True)

        cmd.stdout = result.stdout.decode("utf-8")
        cmd.stderr = result.stderr.decode("utf-8")

    except subprocess.CalledProcessError as e:
        cmd.succeeded = False
        cmd.returncode = e.returncode
        cmd.stdout = e.stdout.decode("utf-8")
        cmd.stderr = e.stderr.decode("utf-8")

    except subprocess.TimeoutExpired as e:
        cmd.succeeded = False
        cmd.stdout = 'COMMAND TIMEOUT ({}s)'.format(e.timeout)

    except Exception as e:
        cmd.succeeded = False
        cmd.stdout = ''
        if hasattr(e, 'message'):
            cmd.stderr = e.message
        else:
            cmd.stderr = str(e)
    else:
        cmd.returncode = 0
        cmd.succeeded = True
    finally:
        return cmd


def checkPackage(package):
    cmd = runCmd(['dpkg', '-s', package])
    if cmd.succeeded and 'Status: install ok installed' in cmd.stdout:
        return True
    else:
        return False

    
def getRepoList():
    repoList = []

    for root, dirs, files in os.walk('/etc/apt/'):
        for file in files:
            if file.endswith(".list"):
                with open(os.path.join(root, file)) as f:
                    lines = f.readlines()

                    for line in lines:
                        if re.match('^deb http:\/\/ppa\.launchpad\.net\/[a-z0-9\-]+\/[a-z0-9\-]+', line):
                            data = line.split('/')
                            repoList.append('ppa:' + data[3] + '/' + data[4])

    return repoList


def notify(message):
    userID = runCmd(['id', '-u', os.environ['SUDO_USER']]).stdout.replace('\n', '')
    runCmd(['sudo', '-u', os.environ['SUDO_USER'], 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/{}/bus'.format(userID), 
            'notify-send', '-i', 'utilities-terminal', 'PWLinux installer', message])


def waitForDpkgLock():
    tries = 0

    while True:
        dpkgLock = runCmd(['fuser', '/var/lib/dpkg/lock'])
        aptLock = runCmd(['fuser', '/var/lib/apt/lists/lock'])
        
        if dpkgLock.stdout != '' or aptLock.stdout !='':
            time.sleep(3)
            tries += 1
        else:
            return True

        if tries > 10:
            return False


def get_password(text):  
    result = runCmd(['./yad', 
                    '--class="GSu"', 
                    '--text=' + text,
                    '--image="dialog-password"', 
                    '--title=Password', 
                    '--entry', 
                    '--hide-text', 
                    '--undecorated',
                    '--skip-taskbar'
                    ]) 

    return result                      


class Yad:

    def __init__(self):
        pass

    @staticmethod
    def password():
        runCmd(['sudo', '-k'])

        count = 0
        while True:
            count += 1
            if count == 1:
                getPasswordCmd = get_password('Enter sudo password...')
            else:
                getPasswordCmd = get_password('Wrong password. Try again...')

            if getPasswordCmd.succeeded:
                checkPasswordCmd = runCmd(['sudo', 
                                            '-S', 
                                            'id', 
                                            '-u'],
                                            stdin=getPasswordCmd.stdout + '\n')
                if checkPasswordCmd.succeeded and checkPasswordCmd.stdout.replace('\n', '') == '0':
                    return getPasswordCmd.stdout.replace('\n', '')
                    
            else:
                sys.exit()


    @staticmethod
    def progressBar(pulsating=False, noCancel=True, title='', text='', percentage=0, height=300, width=720):

        args = ['./yad', '--progress']

        if pulsating:
            args.append('--pulsate')

        if noCancel:
            args.append('--no-cancel')

        args.append('--title={}'.format(title))
        args.append('--text={}'.format(text))
        args.append('--percentage={}'.format(percentage))
        args.append('--height={}'.format(height))
        args.append('--width={}'.format(width))
        args.append('--window-icon=pwlinux.png')
        args.append('--enable-log')
        args.append('--log-expanded')   
        args.append('--log-on-top')         
        args.append('--log-height=300')
        args.append('--center')
        

        process = subprocess.Popen(args, 
                                   stdin=subprocess.PIPE, 
                                   stdout=subprocess.PIPE, 
                                   stderr=subprocess.PIPE)

        def update(message='', percent=0):

            process.stdin.write((str(percent) + '\n').encode())
            process.stdin.flush()

            if message:
                process.stdin.write(('# %s\n' % str(message)).encode())
                process.stdin.flush()

            return process.returncode

        return update


    @staticmethod
    def error(message):
        runCmd(['./yad', 
                '--error', 
                '--title=PWLinux installer', 
                '--height=100',
                '--width=500',
                '--window-icon=pwlinux.png',
                '--text={}'.format(message)])


    @staticmethod
    def table(data):
        args = ['./yad',
                '--list',
                '--checklist',
                '--height=720',
                '--width=1000',
                '--title=PWLinux installer',
                '--window-icon=pwlinux.png',
                '--text=Select tasks to perform:',
                '--column=Selection',
                '--column=Task',
                '--center',
                '--column=Description']        

        args.extend(data)

        return runCmd(args)


    @staticmethod
    def info(message):
        runCmd(['./yad', 
                '--info', 
                '--title=PWLinux installer',
                '--window-icon=pwlinux.png',
                '--height=100',
                '--width=200',
                '--text={}'.format(message)])


    @staticmethod
    def question(message, height=100, width=200):
        question = runCmd(['./yad', 
                           '--question', 
                           '--title=PWLinux installer',
                           '--window-icon=pwlinux.png',
                           '--height={}'.format(height),
                           '--width={}'.format(width),
                           '--text={}'.format(message)])

        return question.succeeded

    
    @staticmethod
    def textInfo(message):
        data = runCmd(['echo', message]).stdout
        runCmd(['./yad',
                '--text-info',
                '--height=700',
                '--width=800',
                '--center',
                '--title=PWLinux installer',
                '--window-icon=pwlinux.png'],
                stdin=data)

    
    @staticmethod
    def list(message, elements):
        cmd = ['./yad',
                '--list',
                '--height=500',
                '--width=500',
                '--title=PWLinux installer',
                '--window-icon=pwlinux.png',
                '--text={}'.format(message),
                '--hide-header', 
                '--column', 'Tasks with errors']

        cmd.extend(elements)
        runCmd(cmd)


class GUI:

    def __init__(self):
        self.logFile = '/var/log/PWLinux.log'

        with open(self.logFile, 'a') as f:
            f.write(100 * '=' + '\n')
            f.write('NEW SESSION ' + datetime.now().strftime('%Y-%m-%d %H:%M:%S') + '\n')
            f.write(runCmd(['lsb_release', '-d']).stdout)
            f.write(runCmd(['uname', '-a']).stdout)

        self.errors = []

        # Set language
        runCmd(['export','LC_ALL=C'])

        # Check distro
        supportedDistro = False

        with open('/etc/os-release','r') as f:
            lines = f.readlines()

            for line in lines:
                if line == 'ID_LIKE=ubuntu\n' or line == 'ID_LIKE=debian\n' or line == 'ID=debian\n':
                    supportedDistro = True
                    break

        if not supportedDistro:
            message = "This is not an Ubuntu or Ubuntu derivative distro. You can't run PWLinux installer on this system."
            Yad.error(message)
            print(message)

            sys.exit()

        # Check architecture
        arch = self.runAndLogCmd(['uname', '-m'])

        if arch.stdout != 'x86_64\n':
            message = "This is not a 64-bit system. You can't run PWLinux installer on this system."
            Yad.error(message)
            print(message)
            sys.exit()

        # Check /var/lib/dpkg/lock to ensure we can install packages
        lock = runCmd(['fuser', '/var/lib/dpkg/lock'])

        if lock.stdout != '':
            message = 'Another program is installing or updating packages. Please wait until this process finishes and then launch PWLinux installer again.'

            Yad.error(message)
            print(message)
            sys.exit()

        # Check connectivity
        ping = self.runAndLogCmd(['ping', '-c', '1', 'google.com'])

        if not ping.succeeded:
            message = 'There is no connection to the Internet. Please connect and then launch PWLinux installer again.'
            Yad.error(message)
            print(message)

        # Repair installation interruptions
        self.runAndLogCmd(['dpkg', '--configure', '-a'])

        # Get repositories
        self.repoList = getRepoList()      

        with open('recipes.json', 'r') as f:
            self.recipes = json.load(f)   

        # Set recipe selections to false
        for i in range(len(self.recipes)):
            self.recipes[i]['selected'] = False

    
    def show(self):

        while True:
            # Build table
            tableData = []
        
            for recipe in self.recipes:
                if recipe['selected']:
                    select = 'TRUE'
                else:
                    select = 'FALSE'

                tableData.append(select)
                tableData.append(recipe['name'])
                tableData.append(recipe['description'])
            
            table = Yad.table(tableData)

            # Check for closed window / cancel button
            if not table.succeeded:
                sys.exit()

            # Check zero tasks selected
            if table.stdout == '':
                Yad.info('No tasks were selected')

                for i in range(len(self.recipes)):
                    self.recipes[i]['selected'] = False

                continue

            else:
                taskList = table.stdout[:-1].split('|') # Last char is \n

                self.taskList = []

                for i in range(len(self.recipes)):
                    if self.recipes[i]['name'] in taskList:
                        self.taskList.append(i)
                        self.recipes[i]['selected'] = True
                    else:
                        self.recipes[i]['selected'] = False

                break


    def process(self):
        # Get confirmation
        message = 'The selected tasks will be performed now. '
        message += "You won't be able to cancel this operation once started.\n\n"       
        message += 'Are you sure you want to continue?'

        while True:
            if not Yad.question(message, height=100, width=350):
                self.show()
            else:
                break

        # Collect commands info
        ppas = []
        packages = []
        snaps = []
        snapsWithOptions = []
        debs = []
        generics = []
        preInstall = []
        postInstall = []

        for i in self.taskList:

            if self.recipes[i]['type'] == 'package':
                packages.extend(self.recipes[i]['recipe'])

            elif self.recipes[i]['type'] == 'snap':
                if len(self.recipes[i]['recipe']) == 1:
                    snaps.extend(self.recipes[i]['recipe'])
                else:
                    snapsWithOptions.append(self.recipes[i]['recipe'])

            elif self.recipes[i]['type'] == 'ppa':
                ppas.append(self.recipes[i]['recipe'][0])
                packages.extend(self.recipes[i]['recipe'][1:])

            elif self.recipes[i]['type'] == 'deb':
                debs.append(self.recipes[i]['recipe'][0])
            elif self.recipes[i]['type'] == 'generic':
                generics.append(self.recipes[i]['recipe'])

            if 'preInstall' in self.recipes[i]:
                preInstall.append(self.recipes[i]['preInstall'])

            if 'postInstall' in self.recipes[i]:
                postInstall.append(self.recipes[i]['postInstall'])


        # Skip already installed ppas
        for i in reversed(range(len(ppas))):
            if ppas[i] in self.repoList:
                ppas.pop(i)

        # Skip already installed packages
        for i in reversed(range(len(packages))):
            if checkPackage(packages[i]):
                packages.pop(i)

        # Create progress bar
        updateBar = Yad.progressBar(pulsating=True, 
                                       noCancel=True, 
                                       title='PWLinux installer',
                                       text='Processing tasks')

        try:
            #Ensure git is installed
            if not checkPackage('git'):
                updateBar('Installing git')
                self.runAndLogCmd(['apt-get', 'install', '-y', 'git'], checkLock=True)            

            # Ensure software-properties-common is installed
            if len(ppas) > 0 and not checkPackage('software-properties-common'):
                updateBar('Installing software-properties-common')
                self.runAndLogCmd(['apt-get', 'install', '-y', 'software-properties-common'], checkLock=True)

            # Ensure snapd is installed
            if (len(snaps) > 0 or len(snapsWithOptions) > 0) and not checkPackage('snapd'):
                updateBar('Installing snapd')
                self.runAndLogCmd(['apt-get', 'install', '-y', 'snapd'], checkLock=True)

            # Ensure libnotify-bin is installed
            if not checkPackage('libnotify-bin'):
                updateBar('Installing libnotify-bin')
                self.runAndLogCmd(['apt-get', 'install', '-y', 'libnotify-bin'], checkLock=True)

            # Run pre-installation tasks
            if len(preInstall) > 0:
                updateBar('Processing pre-installation tasks')
                for i in preInstall:
                    self.runAndLogCmd(i)

            # Process ppas
            if len(ppas) > 0:
                for ppa in ppas:
                    updateBar('Adding {}'.format(ppa))
                    self.runAndLogCmd(['add-apt-repository', '-y', ppa], checkLock=True)

            # Update
            if len(packages) > 0 or len(ppas) > 0:
                updateBar('Updating package list')
                self.runAndLogCmd(['apt-get', 'update'], checkLock=True)

            # Process packages
            if len(packages) > 0:
                for package in packages:
                    updateBar('Installing {}'.format(package))
                    cmd = ['apt-get', 'install', '-y']
                    cmd.append(package)
                    self.runAndLogCmd(cmd, checkLock=True)

            # Process snaps
            if len(snaps) > 0:
                for snap in snaps: # Install one by one to avoid hanging
                    updateBar('Installing {}'.format(snap))
                    cmd = ['snap', 'install']
                    cmd.append(snap)
                    self.runAndLogCmd(cmd)

            # Process snaps with options
            if len(snapsWithOptions) > 0:
                for snap in snapsWithOptions:
                    updateBar('Installing {}'.format(snap[0]))
                    cmd = ['snap', 'install']
                    cmd.extend(snap)
                    self.runAndLogCmd(cmd)

            # Process debs
            if len(debs) > 0:
                for deb in debs:
                    updateBar('Installing {}'.format(deb))
                    self.runAndLogCmd(['wget', '-q', '-O', '/tmp/package.deb', deb])
                    self.runAndLogCmd(['apt-get', 'install', '-y', '/tmp/package.deb'], checkLock=True)

            # Process generics
            if len(generics) > 0:
                for cmds in generics:
                    updateBar('Running {}'.format(' '.join(cmds)))
                    self.runAndLogCmd(cmds, checkLock=True)

            # Run post-installation tasks
            if len(postInstall) > 0:
                updateBar('Processing post-installation tasks')
                for i in postInstall:
                    self.runAndLogCmd(i)

            # Autoremove
            updateBar('Removing no longer needed packages')
            self.runAndLogCmd(['apt-get', 'autoremove', '-y'], checkLock=True)

            # Check errors and notify
            if len(self.errors) == 0:
                message = "All tasks completed succesfully. If you can't find some of the installed apps, reboot your computer."
            else:
                self.runAndLogCmd(['dpkg', '--configure', '-a'])
                message = 'Some tasks ended with errors and may not have been correctly installed. Check the lock at ' + self.logFile

            notify(message)
            updateBar(message)

            if len(self.errors) > 0:
                log = ''

                with open(self.logFile, 'r') as f:
                    lines = f.readlines()

                    for i in reversed(range(len(lines))):
                        if lines[i].startswith('NEW SESSION'):
                            log = ''.join(lines[i:])
                            break

                Yad.list('The following tasks ended with errors and could not be completed:', self.errors)
                
                if len(log) < 120000:
                    Yad.textInfo(
                        'Ooops, some errors happened (sorry about that).' + log
                    )
                else:
                    Yad.textInfo(
                        'Ooops, some errors happened (sorry about that)' +
                        log[:120000]
                    )  # TODO: Legg inn referanse til log-fil path
        finally:

            # Change log ownership
            runCmd(['chown', '{}:{}'.format(os.environ['SUDO_USER'], os.environ['SUDO_USER']), self.logFile])



    def runAndLogCmd(self, cmdArgs, checkLock=False):

        if checkLock:
            if not waitForDpkgLock(): # Wait for /var/lib/dpkg/lock to be released

                with open(self.logFile, 'a') as f:
                    f.write(100 * '-' + '\n')
                    f.write('LOCKED /var/lib/dpkg/lock or /var/lib/apt/lists/lock\n')
                    Yad.error('Another program is installing or updating packages. Please wait until this process finishes and then launch PWLinux installer again.')
                    sys.exit()

        with open(self.logFile, 'a') as f:
            f.write(100 * '-' + '\n')
            f.write('<COMMAND>: ' + ' '.join(cmdArgs) + '\n')

        cmd = runCmd(cmdArgs)

        with open(self.logFile, 'a') as f:
            if cmd.succeeded:
                f.write('<RESULT>: SUCCESS\n')
            else:
                f.write('<RESULT>: ERROR\n')
                self.errors.append(cmd.cmd)

            f.write('<STDOUT>:\n' + cmd.stdout + '\n')
            f.write('<STDERR>:\n' + cmd.stderr + '\n')

        return cmd


def main():
    directory = os.path.abspath(os.path.dirname(__file__))
    os.chdir(directory)  
    file_name = os.path.basename(__file__)

    # Check root privileges
    if os.geteuid() == 0:           
        gui = GUI()
        gui.show()
        gui.process()
    else: 
        runCmd(['sudo', 'python3', file_name], stdin=Yad.password())


if __name__ == '__main__':
    main()