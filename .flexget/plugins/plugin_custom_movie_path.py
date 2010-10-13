import logging
from flexget.plugin import *

log = logging.getLogger('custom_movie_path')

class CustomMoviePath(object):
    """
    Alters the path of the movie if:
        - english is not the primary language
        - it is a documentary
    """

    # Run after filter_imdb which has the default priority of 128
    @priority(127)

    def validator(self):
        from flexget import validator
        config = validator.factory('dict')
        # Don't specify these as paths as they might need to be created
        config.accept('text', key='foreign', allow_replacement=True)
        config.accept('text', key='documentary', allow_replacement=True)
        return config

    def on_feed_modify(self, feed):
        if not feed.config.get('imdb'):
            log.error('imdb plugin is not enabled on this feed. custom_movie_path only works with the imdb plugin.')
            return

        foreign_path = feed.config.get('foreign')
        documentary_path = feed.config.get('documentary')

        for entry in feed.accepted:
            if foreign_path and 'english' == entry['imdb_languages'][0]:
                entry['path'] = foreign_path
                log.debug('%s is a foreign film' % (entry['imdb_name']))
                continue
            elif documentary_path and 'documentary' in entry['genres']:
                entry['path'] = documentary_path
                log.debug('%s is a documentary' % (entry['imdb_name']))

register_plugin(CustomMoviePath, 'custom_movie_path', debug=True)
