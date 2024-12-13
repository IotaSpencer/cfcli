require 'cloud_party'
require 'configparser'

cf_cfg_path = Pathname.new(Dir.home).join('.cloudflare', 'cloudflare.cfg')
cfg = ConfigParser.new(cf_cfg_path)
token = cfg['Cloudflare']['bearer']

