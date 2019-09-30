import os
import sys
import subprocess

def git_pull(branch):
    print('pulling {}'.format(branch))
    print('--------' * 5)
    os.system("git pull origin {}".format(branch))
    print('--------' * 5)

def get_heroku_envs():
    selected_branch = sys.argv[1]

    if selected_branch == 'production':
        selected_app = 'mvpinvest'
    else:
        selected_app = 'banfox-main-app-staging'

    heroku_keys = []
    heroku_data = subprocess.Popen('heroku config --app ' + selected_app,
                        shell=True,
                        stdout=subprocess.PIPE
                        )
    heroku_lines = str(heroku_data.stdout.read()).split('\\n')

    for line in heroku_lines[1:]:
        data = line.split(':', 1)
        heroku_keys.append(data[0])

    return heroku_keys

def get_local_envs():
    local_keys = []
    local_data = subprocess.Popen('cat .env',
                        shell=True,
                        stdout=subprocess.PIPE
                        )
    local_lines = str(local_data.stdout.read()).split('\\n')

    for line in local_lines[1:]:
        data = line.split('=', 1)
        local_keys.append(data[0])

    return local_keys

def get_selection_from_arguments():
    selected_branch = ''
    branches = subprocess.Popen('git branch',
                        shell=True,
                        stdout=subprocess.PIPE
                        )

    branches = branches.stdout.read()
    branches = str(branches).split('\\n')
    branches = [branch for branch in branches if branch[0] == '*']

    if any(branches):
        selected_branch = branches[0].split(' ')[1]

    if selected_branch == 'production':
        selected_app = 'mvpinvest'
    elif selected_branch == 'staging':
        selected_app = 'banfox-main-app-staging'
    else:
        print("There's no application for the current branch")
        return [False, False]

    return [selected_app, selected_branch]

def main():
    selected_app, selected_branch = get_selection_from_arguments()

    if selected_branch is False:
        return

    error_with_environment = False
    heroku_envs = get_heroku_envs()
    local_envs = get_local_envs()

    for local_key in local_envs:
        if local_key not in heroku_envs:
            error_with_environment = True
            print('ENV variable missing in environment detected: {}'.format(local_key))

    if not error_with_environment:
        print('Environment seems ok, proceed with deploy')
        os.system('git checkout {}'.format(selected_branch))
        os.system('heroku git:remote --app {}'.format(selected_app))
        os.system('git push heroku {}:master'.format(selected_branch))
        os.system('heroku run rails db:migrate --app {}'.format(selected_app))
        os.system('heroku restart --app {}'.format(selected_app))

if __name__ == '__main__':
    main()
