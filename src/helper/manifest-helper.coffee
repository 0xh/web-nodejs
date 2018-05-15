import fs 	from 'fs'
import path from 'path'


export default class ManifestHelper
	constructor: (@path, @assetPath = '/build', @cache = false, @manifest = null) ->

	loadManifest: () ->
		if (@manifest && @cache)
			return manifest

		try
			return JSON.parse fs.readFileSync(@path, 'utf8')
		catch error
			throw new Error 'Asset Manifest could not be loaded.'

	lookup: (asset) ->
		@manifest = @loadManifest()
		return if @manifest[asset] then path.join(@assetPath, @manifest[asset]) else asset

	helper: () ->
		return (asset) =>
			return @lookup asset
