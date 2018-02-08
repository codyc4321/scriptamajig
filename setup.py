from setuptools import setup 

setup(
    name='scriptamajig',
    version='0.1.0',
    description='A CLI for organizing and quickly locating/describing your bash aliases and whatnot',
    url='https://github.com/codyc4321/scriptamajig_nodejs',
    author='Cody Childers',
    author_email='cchilderswork@gmail.com',
    license='MIT',
    packages=['scriptamajig'],
    install_requires=[],
    zip_safe=False,
    entry_points={
        'console_scripts': [
            'scriptamajig = scriptamajig.__main__:main',
        ]
    },
)