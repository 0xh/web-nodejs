
import fs 			from 'fs'
import nib 			from 'nib'
import stylus 		from 'stylus'
import Asset 		from './asset'

export default class StylusAsset extends Asset

	mime: 'text/css'

	compile:->

		return new Promise (resolve, reject)=>

			fs.readFile @resource, 'utf8', (error, str)=>
				if error
					return reject error

				s = stylus str
					.set 'filename', @resource
					.set 'include css', true
					.set 'compress', !@debug

					# always import nib
					.use nib()
					.import 'nib'

				if @debug
					s.set 'sourcemap', {
						inline: true
					}

				s.render (error, result)->
					if error
						return reject error

					resolve result
