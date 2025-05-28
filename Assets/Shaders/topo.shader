Shader "Unlit/topo"
{
    Properties
    {
        _MinY ("Minimum Y", Float) = 0
        _MaxY ("Maximum Y", Float) = 1
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _BandCnt ("Band count", Float) = 5
        _BandCntMin ("Band Count Min", Float) = 1
        _BandCntMax ("Band Count Max", Float) = 20
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 wPos : TEXCOORD1; // Will use this to store world pos
            };
            
            float _MinY;
            float _MaxY;
            sampler2D _RampTex;
            float4 _RampTex_ST;
            float _BandCnt;

            v2f vert (appdata v)
            {
                v2f o;

                // I think this is like the out keyword in glsl
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _RampTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed u = (i.wPos.y - _MinY) / (_MaxY - _MinY);
                u = saturate(u);
                
                int bandCount = (int)_BandCnt;
                u = floor(u * bandCount) / bandCount;   // Seperate into bands

                // sample the texture using the u value
                // I think this is like Texture2D() in glsl
                fixed4 col = tex2D(_RampTex, fixed2(u, 0.5));

                // like older gl_FragColor in glsl
                return col;
                // return fixed4(u, 0, 0, 1);   // DEBUG
            }
            ENDCG
        }
    }
    CustomEditor "TopoShaderGUI"
}
