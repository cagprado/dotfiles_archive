def sanitize_attachment_filename(filename=None, prefix='', suffix=''):
    '''Add file extension to 'suffix' if 'filename' is given.'''
    if filename is not None:
        suffix = '-' + filename + suffix
    return (prefix, suffix)
