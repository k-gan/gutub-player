#!/usr/bin/ruby

require 'vrlib'
require 'youtube_it'
require 'awesome_print'
require 'open-uri'
require 'yaml'
require 'nokogiri'
require 'ostruct'
require 'cgi'

#make program output in real time so errors visible in VR.
STDOUT.sync = true
STDERR.sync = true

#everything in these directories will be included
my_path = File.expand_path(File.dirname(__FILE__))
require_all Dir.glob(my_path + "/bin/**/*.rb")

Gutub.new.show
