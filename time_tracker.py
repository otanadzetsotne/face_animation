import os
import logging


def tracker_logs_default():
    script = os.path.abspath(__file__)
    project_dir = os.path.dirname(script)
    logs_path = os.path.join(project_dir, 'time_tracking.logs')
    return logs_path


if __name__ == '__main__':
    tracker_logs = os.environ.get('TIME_TRACKING_LOGS', tracker_logs_default())
    logging.basicConfig(
        filename=tracker_logs,
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
