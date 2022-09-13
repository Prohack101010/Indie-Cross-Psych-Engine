package;

import openfl.filters.ShaderFilter;
import Shaders;

class ChromaticAberration extends Shaders
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new ChromaticAberration(offset)) {
    chromaticAberration.rOffset.value = [offset];
    chromaticAberration.gOffset.value = [0.0];
    chromaticAberration.bOffset.value = [-offset];
	}
	public static function setChrome(chromeOffset:Float):Void
	{
		chromaticAberrationShader.shader.data.rOffset.value = [chromeOffset];
		chromaticAberrationShader.shader.data.gOffset.value = [0.0];
		chromaticAberrationShader.shader.data.bOffset.value = [chromeOffset * -1];
	}
}
