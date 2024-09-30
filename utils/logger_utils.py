import logging
import os


def setup_logger(name, log_file=None, console_level=logging.INFO, file_level=logging.DEBUG, console_format_str=None, file_format_str=None):
    """
    Set up a logger that writes to both a file and the console, with different formats and levels.
    
    :param name: Name of the logger.
    :param log_file: Path to the log file.
    :param console_level: Logging level for the console output.
    :param file_level: Logging level for the file output.
    :return: Configured logger.
    """
    have_console_handler = console_level is not None
    have_file_handler = file_level is not None
    if log_file is None:
        log_file = os.path.join('logs', f'{name}.log')
    # Directory
    directory = os.path.dirname(log_file)
    if directory and not os.path.exists(directory):
        os.makedirs(directory)
        
    print(f"have_console_handler={have_console_handler}, have_file_handler={have_file_handler}", log_file, directory)
    # Create a custom logger
    logger = logging.getLogger(name)
    
    if not logger.hasHandlers():
        logger.setLevel(logging.DEBUG)  # Set the overall logger level to the lowest level you want to capture
        # Console handler
        if have_console_handler:
            console_handler = logging.StreamHandler()  # For console output
            console_handler.setLevel(console_level)
            if not console_format_str:
                console_format_str = '%(name)s - %(levelname)s - %(message)s'
            console_format = logging.Formatter(console_format_str)
            console_handler.setFormatter(console_format)
            logger.addHandler(console_handler)
        
        # File handler
        if have_file_handler:
            file_handler = logging.FileHandler(log_file)  # For file output
            file_handler.setLevel(file_level)
            if not file_format_str:
                file_format_str = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
            file_format = logging.Formatter(file_format_str)
            file_handler.setFormatter(file_format)
            logger.addHandler(file_handler)
    
    return logger
