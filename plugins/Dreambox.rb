##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
Plugin.define "Dreambox" do
author "Brendan Coles <bcoles@gmail.com>" # 2011-05-30
version "0.1"
description "The Dreambox is a series of Linux-powered DVB satellite, terrestrial and cable digital television receivers (set-top box), produced by German multimedia vendor Dream Multimedia. Enigma2 WebInterface - Control a DreamBox using a Browser. The Dreambox Webinterface (short WebIf) is included in all newer Images. - More info: http://en.wikipedia.org/wiki/Dreambox"
# More info on Enigma2: http://dream.reichholf.net/wiki/Enigma2:WebInterface

# ShodanHQ results as at 2011-05-30 #
# 5,104 for Enigma2 WebInterface Server
# 2,372 for Enigma2 TwistedWeb realm
#    24 for TwistedWeb realm dm

# Examples #
examples %w|
81.191.95.225
91.153.31.8
83.183.203.64
84.75.136.8
213.3.4.128
188.195.32.115
217.117.134.75
85.228.161.169
|

# Matches #
matches [

# Aggressive # /web-data/img/favicon.ico
{ :url=>"/web-data/img/favicon.ico", :md5=>"d9aa63661d742d5f7c7300d02ac18d69" },

]

# Passive #
def passive
	m=[]

	# Version Detection # HTTP Server Header
	m << { :version=>@meta["server"].scan(/^Enigma2 WebInterface Server ([\d\.]+)$/) } if @meta["server"] =~ /^Enigma2 WebInterface Server ([\d\.]+)$/

	# HTTP Server Header # TwistedWeb
	if @meta["server"] =~ /^TwistedWeb\/[\d\.]+$/

		# WWW-Authenticate # basic realm="Enigma2 WebInterface"
		m << { :name=>"TwistedWeb server + WWW-Authenticate realm" } if @meta["www-authenticate"] =~ /^basic realm="Enigma2 WebInterface"$/

		# Title
		m << { :name=>"TwistedWeb server + Title" } if @body =~ /<title>Dreambox WebControl<\/title>/

	end

	# Model Detection # WWW-Authenticate: basic realm
	if @meta["server"] =~ /^Twisted\/[\d\.]+/ and @meta["www-authenticate"] =~ /^basic realm="(dm[\d]{4})"$/i
		m << { :model=>@meta["www-authenticate"].scan(/^basic realm="(dm[\d]{4})"$/i) }
	end

	# Return passive matches
	m
end

end

