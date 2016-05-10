Shader "Wizard/Wizard_Gray" {

	Properties{
		_MainTex("Base", 2D) = "white"
	}

	SubShader{

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		Pass{
	
			Cull Off
			Lighting Off
			ZWrite Off
			Offset -1, -1
			Fog{ Mode Off}
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			struct v2f {
				float4  pos : SV_POSITION;
				float2  uv : TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 texCol = tex2D(_MainTex, i.uv);
				texCol.rgb= dot(texCol.rgb, fixed3(.222, .707, .071));
				return texCol;
			}

			ENDCG
		}
	}
}