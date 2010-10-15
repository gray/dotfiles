import logging
from flexget.plugin import *

log = logging.getLogger('custom_movie_path')

class CustomMoviePath(object):
    """
    Alters the path of the movie if:
        - english is not the primary language
        - it is a documentary

    custom_movie_path:
      default: /default/movie/path
      documentary: /path/for/documentaries
      foreign: /path/for/for/foreign/films
    """

    # Run after filter_imdb which has the default priority of 128
    @priority(127)

    def validator(self):
        from flexget import validator
        config = validator.factory('dict')
        # Don't specify these as paths as they might need to be (re)created
        config.accept('text', key='default')
        config.accept('text', key='documentary')
        config.accept('text', key='foreign')
        return config

    def on_feed_modify(self, feed):
        if not feed.config.get('imdb'):
            log.error('imdb plugin is not enabled on this feed. custom_movie_path only works with the imdb plugin.')
            return

        config = feed.config.get('custom_movie_path', {})
        default = config.get('default')
        documentary = config.get('documentary')
        foreign = config.get('foreign')
        if not default and not documentary and not foreign:
            return

        for entry in feed.accepted:
            if foreign and 'english' != entry['imdb_languages'][0]:
                entry['path'] = foreign
                log.debug('%s is a foreign film' % (entry['imdb_name']))
                continue
            elif documentary and 'documentary' in entry['imdb_genres']:
                entry['path'] = documentary
                log.debug('%s is a documentary' % (entry['imdb_name']))
            elif default:
                entry['path'] = config.get('default')

register_plugin(CustomMoviePath, 'custom_movie_path', debug=True)
