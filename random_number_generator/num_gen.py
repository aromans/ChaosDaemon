import time
import random
import logging
import sys


if __name__ == "__main__":
    FMT = '%(asctime)-15s %(message)s'
    logging.basicConfig(format=FMT, stream = sys.stdout, level = logging.INFO)
    logger = logging.getLogger('random_num_gen')
    for i in range(500):
        num = random.randint(0, 200)
        logger.info(num)
        time.sleep(1)