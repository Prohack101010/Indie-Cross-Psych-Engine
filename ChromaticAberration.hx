package;

import openfl.filters.ShaderFilter;

class ChromaticAberration
{
	public static var Shaders:ShaderFilter = new ShaderFilter(new Shaders());

	public static function setChrome(chromeOffset:Float):Void
	{
		Shaders.shader.data.rOffset.value = [chromeOffset];
		Shaders.shader.data.gOffset.value = [0.0];
		Shaders.shader.data.bOffset.value = [chromeOffset * -1];
	}
} 
