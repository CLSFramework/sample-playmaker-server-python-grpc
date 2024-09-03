
import pkg_resources
import sys

def check_requirements(requirements_file='requirements.txt'):
    with open(requirements_file, 'r') as file:
        requirements = file.readlines()

    for requirement in requirements:
        requirement = requirement.strip()
        try:
            pkg_resources.require(requirement)
        except pkg_resources.VersionConflict as e:
            print(f"WARNING: {str(e)}")
        except pkg_resources.DistributionNotFound as e:
            print(f"ERROR: {str(e)}")
            sys.exit(1)

if __name__ == "__main__":
    check_requirements()
