import logging
from flexget.plugin import *

log = logging.getLogger('foreign_movie')

class ForeignMovie(object):
    """
    Alters the path if the primary language of the movie is not english.
    """

    # Run after filter_imdb which has the default priority of 128
    @priority(127)

    def validator(self):
        from flexget import validator
        config = validator.factory()
        config.accept('path', allow_replacement=True)
        return config

    def get_config(self, feed):
        config = {}
        config['path'] = feed.config['foreign_movie']
        return config

    def on_feed_modify(self, feed):
        if not feed.config.get('imdb'):
            log.error('imdb plugin is not enabled on this feed. foreign_movie only works with the imdb plugin.')
            return
        for entry in feed.accepted:
            langs = entry['imdb_languages']
            if langs and 'english' != langs[0]:
                entry['path'] = feed.config.get('foreign_movie')
                log.debug('%s is a foreign film' % (entry['imdb_name']))

register_plugin(ForeignMovie, 'foreign_movie', debug=True)
