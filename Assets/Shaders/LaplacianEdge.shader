Shader "Custom/LaplacianEdge"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _ThresholdMin ("Threshold Min", Range(0, 0.2)) = 0.05
        _ThresholdMax ("Threshold Max", Range(0, 0.2)) = 0.15
        _ColorBg ("Background Color", Color) = (0.5, 0.5, 0.5, 1)
        _ColorLine ("Line Color", Color) = (1, 1, 1, 1)
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

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float _ThresholdMin;
            float _ThresholdMax;
            fixed4 _ColorBg;
            fixed4 _ColorLine;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            #define LUM(c) ((c).r * 0.3 + (c).g * 0.59 + (c).b * 0.11)

            fixed4 frag (v2f i) : SV_Target
            {
                // For Laplacian kernel, the version using only 5 pixels in the neighborhood
                float3 C = tex2D(_MainTex, i.uv).rgb;
                float3 N = tex2D(_MainTex, i.uv + fixed2(0, _MainTex_TexelSize.y)).rgb;
                float3 S = tex2D(_MainTex, i.uv - fixed2(0, _MainTex_TexelSize.y)).rgb;
                float3 W = tex2D(_MainTex, i.uv - fixed2(_MainTex_TexelSize.x, 0)).rgb;
                float3 E = tex2D(_MainTex, i.uv + fixed2(_MainTex_TexelSize.x, 0)).rgb;

                // Use "luminance" value to differentiate colors based on rgb
                float lumC = LUM(C);
                float lumN = LUM(N);
                float lumS = LUM(S);
                float lumW = LUM(W);
                float lumE = LUM(E);

                float laplacian = saturate(lumN + lumS + lumW + lumE - 4.0 * lumC);
                laplacian = smoothstep(_ThresholdMin, _ThresholdMax, laplacian);

                fixed3 color = lerp(_ColorBg.rgb, _ColorLine.rgb, laplacian);
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
