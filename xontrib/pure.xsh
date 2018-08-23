import subprocess
from xonsh.prompt.gitstatus import gitstatus


def human_readable_time(seconds):
    m, s = divmod(seconds, 60)
    h, m = divmod(m, 60)
    d, h = divmod(h, 24)

    result = ''

    if d > 0:
        result += f'{d}d '
    if h > 0:
        result += f'{h}h '
    if m > 0:
        result += f'{m}m '
    result += f'{s}s'

    return result


@events.on_postcommand
def pure_command_time(cmd, rtn, out, ts):
    command_time = ''

    start_time, end_time = ts
    elapsed = end_time - start_time

    if elapsed > ${...}.get('PURE_CMD_MAX_EXEC_TIME', 5):
        command_time = human_readable_time(int(elapsed))

    $PROMPT_FIELDS['pure_command_time'] = command_time


def pure_gitstatus():
    try:
        status = gitstatus()
    except subprocess.SubprocessError:
        return None

    component_branch = '{#6c6c6c}' + status.branch

    if status.operations:
        component_branch += '|' + '|'.join(status.operations)

    if status.staged + status.conflicts + status.changed + status.untracked > 0:
        component_branch += '*'

    component_branch += '{NO_COLOR}'

    component_arrows = []

    if status.num_ahead > 0:
        component_arrows.append('{CYAN}⇡')

    if status.num_behind > 0:
        component_arrows.append('{CYAN}⇣')

    component_arrows.append('{NO_COLOR}')
    
    return ' '.join([
        component_branch,
        ''.join(component_arrows)
    ])


def pure_prompt_end():
    if __xonsh_history__.rtns:
        prompt_color = '{PURPLE}' if __xonsh_history__.rtns[-1] == 0 else '{RED}'
    else:
        prompt_color = '{PURPLE}'

    return prompt_color + '❯{NO_COLOR} '


def pure_prompt():
    return '\n{BLUE}{cwd}{NO_COLOR}{pure_gitstatus: {}}{YELLOW}{pure_command_time: {}}{NO_COLOR}\n' \
           '{pure_prompt_end}'


$PROMPT_FIELDS['pure_command_time'] = ''
$PROMPT_FIELDS['pure_gitstatus'] = pure_gitstatus
$PROMPT_FIELDS['pure_prompt_end'] = pure_prompt_end

$PROMPT = pure_prompt

