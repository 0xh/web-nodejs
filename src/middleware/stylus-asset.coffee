
import fs 			from 'fs'
import nib 			from 'nib'
import stylus 		from 'stylus'
import Asset 		from './asset'

export default class StylusAsset extends Asset

	mime: 'text/css'

	compile:->

		return new Promise (resolve, reject)=>

			fs.readFile @resource, 'utf8', (error, str)=>
				if error then return reject error

				stylus str
					.set 'filename', @resource
					.set 'include css', true
					.set 'compress', true
					.use nib()
					.import 'nib'
					.render (error, result)->
						if error then return reject error

						resolve result
