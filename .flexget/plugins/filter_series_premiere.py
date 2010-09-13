import logging
import re
from flexget.utils.titles import SeriesParser
from flexget.plugin import *

log = logging.getLogger('series_premiere')

class SeriesPremiere(object):
    """
    Accept an entry that appears to be the first episode of any series.

    Examples:

    series_premiere: yes

    series_premiere: ~/Media/TV/_NEW_/.

    series_premiere:
      path: ~/Media/TV/_NEW_/.

    NOTE: this plugin only looks in the entry title and expects the title
    format to start with the series name followed by the episode info.  Use
    the manipulate plugin to modify the entry title to match this format, if
    necessary.

    TODO:
        - add temporary persistence to avoid downloading duplicates
        - integrate thetvdb to allow refining by genres, etc.
    """

    # Run after filter_series which has the default priority of 128.
    @priority(127)

    def validator(self):
        """Return config validator"""
        from flexget import validator
        config = validator.factory()
        config.accept('path', allow_replacement=True)
        config.accept('boolean')
        advanced = config.accept('dict')
        advanced.accept('path', key='path', allow_replacement=True)
        return config

    def get_config(self, feed):
        config = feed.config.get('series_premiere', {})
        if isinstance(config, basestring):
            config = {'path': config}
        return config

    def guess_series(self, data):
        """
        Logic to guess the series name; mostly yanked from SeriesParser.
        """

        def remove_dirt(str):
            """Helper, just replace crap with spaces"""
            return re.sub(r'[-_.\[\]\(\):]+', ' ', str).strip().lower()

        parser = SeriesParser()
        data = parser.clean(data)
        data = remove_dirt(data)
        data = ' '.join(data.split())

        series = {}
        for ep_re in parser.ep_regexps:
            match = re.search(ep_re, data, re.IGNORECASE | re.UNICODE)
            if match:
                matches = match.groups()
                if len(matches) == 2:
                    season = matches[0]
                    episode = matches[1]
                else:
                    # assume season 1 if the season was not specified
                    season = 1
                    episode = matches[0]
                    if not episode.isdigit():
                        roman_to_arabic = {
                            'i': '1', 'ii': '2', 'iii': '3', 'iiii': '4',
                            'iv': '4', 'v': '5', 'vi': '6', 'vii': '7',
                            'viii': '8', 'viiii': '9', 'ix': '9', 'x': '10',
                            'xi': '11', 'xii': '12', 'xiii': '13'
                        }
                        episode = roman_to_arabic.get(episode)

                series['season'] = int(season)
                series['episode'] = int(episode)

                # Anything before the season/episode information is assumed
                # to tbe the series name.
                ep_start, ep_end = match.span()
                name = data[:ep_start]
                name = name.rstrip()
                series['name'] = name

                log.debug('Guessed series: %s, season %s, episode %s' % (
                    series['name'], season, episode))

                return series

    def on_feed_filter(self, feed):
        config = self.get_config(feed)

        for entry in feed.entries:
            if 'series_name' in entry or entry in feed.accepted + feed.rejected:
                continue

            series = self.guess_series(entry['title'])
            if not series or 1 != series['season'] or 1 != series['episode']:
                continue

            entry['series_name'] = series['name']
            entry['series_season'] = series['season']
            entry['series_episode'] = series['episode']

            if 'path' in config:
                entry['path'] = config['path']

            feed.accept(entry, 'series premiere episode')

            log.debug("Premiere found for: %s" % (series['name']))

register_plugin(SeriesPremiere, 'series_premiere', debug=True)
