#!/usr/bin/env python3
import os
import argparse
import jinja2
import logging

logger_name = 'template'
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s')

log_levels = {
    'DEBUG': logging.DEBUG,
    'INFO': logging.INFO,
    'WARNING': logging.WARNING,
    'ERROR': logging.ERROR
}
env_log_level = os.getenv('LOG_LEVEL')

if env_log_level in log_levels.keys():
    log_level = log_levels[env_log_level]
else:
    log_level = logging.INFO

logger = logging.getLogger(logger_name)
logger.setLevel(log_level)
handler = logging.StreamHandler()
handler.setFormatter(formatter)
logger.addHandler(handler)


def is_list(value):
    return isinstance(value, list)


class Template:
    def __init__(self, env_search_term="ENV"):
        self.log_name = f'{logger_name}.{self.__class__.__name__}'
        self.log = logging.getLogger(self.log_name)
        self.path = None
        self.name = None
        self.env_search_term = env_search_term
        self.variables = self._get_variables()

    def _get_variables(self):
        result = {}
        for k, v in os.environ.items():
            if f"{self.env_search_term}_" in k:
                if ";" in v:
                    v = v.replace(" ", "").split(";")
                obj = {k: v}
                result.update(obj)
        self.log.debug(result)
        return result

    def render_template(self, template, output_file):
        """
            Takes template, output file and dictionary of variables.
            Renders template with variables to the specified output file.
        """
        self.path = os.path.dirname(template)
        self.name = os.path.basename(template)
        self.log.debug(
            f"Template path: {'Path_not_provided' if self.path is '' else self.path}"
        )
        self.log.debug(f"Template name: {self.name}")
        # Remove file if exists
        if os.path.exists(output_file):
            self.log.info(f"Removing old file [{output_file}]")
            os.remove(output_file)

        # Write rendered template into file
        self.log.info(f"Rendering template {template} to {output_file}")
        with open(output_file, 'w') as f:
            f.write(
                self._load_template(self.name,
                                    self.path).render(self.variables))

    def _load_template(self, name, path=None):
        """
            Takes template name and a path to the template directory
        """
        # Guessing templates directory
        if path is None or path is "":
            path = os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                'templates')
            self.log.info(f"Missing path to templates. Using default...")
        env = jinja2.Environment(loader=jinja2.FileSystemLoader(path))
        env.filters['is_list'] = is_list
        return env.get_template(name)


def main(template, output_file, env_search_term):
    temp = Template(env_search_term=env_search_term)
    temp.render_template(template=template, output_file=output_file)


if __name__ == "__main__":
    my_parser = argparse.ArgumentParser(
        description='Generate files from jinja templates')
    my_parser.add_argument('--template',
                           dest='template',
                           type=str,
                           help='Choose a template')
    my_parser.add_argument('--output',
                           dest='output_file',
                           type=str,
                           help='Choose a destination')
    my_parser.add_argument('--env-search-term',
                           dest='env_search_term',
                           type=str,
                           default='ENV',
                           help='What should i look for?')
    args = my_parser.parse_args()
    main(template=args.template,
         output_file=args.output_file,
         env_search_term=args.env_search_term)
