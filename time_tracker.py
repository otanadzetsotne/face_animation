import os
import logging
from datetime import datetime


def tracker_logs_file_default():
    script = os.path.abspath(__file__)
    project_dir = os.path.dirname(script)
    logs_path = os.path.join(project_dir, 'time_tracking.logs')
    return logs_path


def calculate_total_work_time(logs):
    time_format = "%Y-%m-%d %H:%M:%S"
    start_time = None
    afk_start = None
    total_time = 0
    afk_time = 0

    for log in logs.split('\n'):
        if not log:
            continue

        time_stamp = datetime.strptime(log[:19], time_format)

        if "Starting time_tracker" in log:
            start_time = time_stamp
        elif "afk start" in log:
            afk_start = time_stamp
        elif "afk stop" in log and afk_start is not None:
            afk_time += (time_stamp - afk_start).total_seconds()
            afk_start = None
        elif "stop" in log and start_time is not None:
            session_time = (time_stamp - start_time).total_seconds() - afk_time
            total_time += session_time
            start_time = None
            afk_time = 0

    total_hours = total_time / 3600
    return total_hours


if __name__ == '__main__':
    tracker_logs_file = os.environ.get('TIME_TRACKING_LOGS', tracker_logs_file_default())
    logging.basicConfig(
        filename=tracker_logs_file,
        filemode='a',
        level=logging.INFO,
        format='%(asctime)s %(name)-12s %(levelname)-8s %(message)-s',
        datefmt='%Y-%m-%d %H:%M:%S',
    )
    logger = logging.getLogger('time_tracker')

    logger.info('Starting time_tracker')
    while True:
        msg = input('Enter completed task: ').strip()

        if msg.lower() == 'stop':
            logger.info(msg)
            break

        if msg:
            logger.info(msg)

    with open(tracker_logs_file, 'r') as f:
        tracker_logs = f.read()
    calculated_time = calculate_total_work_time(tracker_logs)
    print(f'Full working time: {calculated_time:.2f} hours')
