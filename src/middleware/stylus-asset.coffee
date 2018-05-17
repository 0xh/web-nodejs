
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
				s.set 'filename', @resource
				s.set 'include css', true

				if !@debug
					s.set 'compress', true

				s.use nib()
				s.import 'nib'
				s.render (error, result)->
					if error
						return reject error

					resolve result
