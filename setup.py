from setuptools import setup

setup(
    name='xonsh-pure',
    version='0.1.0',
    url='https://github.com/popkirby/xonsh-pure',
    license='MIT',
    author='popkirby',
    author_email='popkirby@gmail.com',
    description='Pure prompt for Xonsh shell',
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    platforms='any',
)
