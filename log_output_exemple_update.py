#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging

# define the log file, file mode and logging level
logging.basicConfig(filename='example.log',
                    filemode="w",
                    format='%(asctime)s -%(name)s-%(levelname)s-%(module)s:%(message)s',
                    level=logging.DEBUG)

logging.debug('This message should go to the log file')
logging.info('So should this')
logging.warning('And this, too')

