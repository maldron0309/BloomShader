Shader "Custom/BloomShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Intensity ("Bloom Intensity", Range(0, 0.4)) = 0.1
        _BrightnessThreshold ("Brightness Threshold", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Intensity;
            float _BrightnessThreshold;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
                half luminance = dot(col.rgb, half3(0.2126, 0.7152, 0.0722));
                half3 brightColor = (luminance > _BrightnessThreshold) ? col.rgb : half3(0, 0, 0);

                // This is a very simple and basic implementation of the bloom effect.
                // For better and optimized results, consider using Unity's Post Processing Stack.
                col.rgb = col.rgb + brightColor * _Intensity;
                return col;
            }
            ENDCG
        }
    }
}
