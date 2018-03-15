require './app'
require 'faye'

use Faye::RackAdapter, :mount => '/faye', :timeout => 25

run ScoutingProject
