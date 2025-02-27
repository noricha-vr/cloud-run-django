import sys
def rename_file(file_name,project_name):
    with open(file_name, 'r') as f:
        text = f.read()
        text = text.replace('hello',project_name)
    with open(file_name, 'w') as f:
        f.write(text)

def set_project_name(project_name):
    rename_file('cloudbuild.yaml',project_name)
    rename_file('docker-compose.yaml',project_name)
    rename_file('README.md',project_name)

if __name__ == '__main__':
    try:
        project_name = sys.argv[1]
    except Exception:
        raise Exception('Please set project name as first param.')
    set_project_name(project_name)
    sys.stdout.write(f'Project Name is {project_name}!')