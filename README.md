# Minecraft PS1 (PSX) Shaders
A Minecraft shader pack for both [OptiFine](https://optifine.net/) and [Iris](https://irisshaders.net/) that mimics the look and feel of PlayStation 1 graphics.

Tested to work with Minecraft 1.19.2 〜 1.7.10, but it most likely will work just fine with newer versions, too.

## Video Demonstration
<a href="https://www.youtube.com/watch?v=6n_WGBEuRGY" target="_blank"><strong>PlayStation 1 Graphics in Minecraft (Minecraft PSX Shader Pack)</strong><br><img src="https://img.youtube.com/vi/6n_WGBEuRGY/maxresdefault.jpg" width="640"></a>

## Installation
Clone this Git repository (if you want the latest changes), or download the latest zipped release.

Place the cloned repository folder or downloaded zip file in your `shaderpacks` folder.

**※ NOTE:** If you don't know where your `shaderpacks` folder is located, you can open it using the "Shaders Folder" button (OptiFine) or the "Open Shader Pack Folder…" button (Iris) on the bottom left of your shader pack selection screen.

## Known Issues
* Beacon beams tilt and do weird things when terrain vertex snapping is on due to [OptiFine issue #4905](https://github.com/sp614x/optifine/issues/4905) (sp614x/optifine#4905).  If anyone knows the block entity ID of beacon beams or whatever it is to single it out in gbuffers_block, please let me know.

* Texture affine mapping behaviour on Iris does not exactly match that of OptiFine's. All affine mapped textures on Iris warp in the opposite direction compared to OptiFine, though this is not noticeable without comparing the two side-by-side.

* In-universe text (signs, player/entity name tags, etc.) can be difficult, if not nearly impossible to read without zooming (or moving very close to the text in question) due to the mesh vertex distortion effect affecting the mesh that in-universe text is rendered to. Glow ink signs are notable for being the most illegible due to the fact that the glow ink effect is in itself rendered as a secondary mesh behind the already-existing text mesh.
	* Text rendering on UI elements (chat, inventory screens, etc.) is completely unaffected.

## License
Licensed under the [MIT License](https://choosealicense.com/licenses/mit/).
