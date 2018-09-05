// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CustomImageEffect/Loop" {
    // シェーダのプロパティ。必要なら追加する。
    Properties {
        // 入力画像がここにはいる
        _MainTex ("Source", 2D) = "white" {}

        _counter ("Counter", Float) = 1
        _strength ("Strength", Float) = 1
    }
    SubShader {
        // 不必要な機能はすべて切る
        ZTest Always
        Cull Off
        ZWrite Off
        Fog { Mode Off }

        Pass{
            // シェーダプログラムの本体
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord.xy);
                return o;
            }

            sampler2D _MainTex;
            float _Brightness;
            float _counter;
            float _strength;

			float yama(float rr, float beki) {

			    float hoge = 0.5 + 0.5 * sin(rr * 3.14 - 3.14 * 0.5);
				//out = pow(out, beki);
				return hoge;// out;

			}

			float yama2(float rr, float beki) {

				float hoge = rr * 2.0;
				if ( hoge < 1.0) {
					hoge = pow(hoge, 1./beki) * 0.5;
				}else {
					hoge = pow(hoge-1.0, beki) * 0.5 + 0.5;
			    }
				//out = pow(out, beki);
				return hoge;// out;

			}

            fixed4 frag(v2f i) : SV_TARGET {

                // ここに表示したい色の計算処理を書く

				float minX = 0.45;
				float maxX = 0.55;
				float amp = maxX - minX;

                //
                float counter = _counter;
                float nn = 10.0 * sin( counter * 0.07 );

                float xx = minX + amp * (0.5 + 0.5 * sin(yama2(i.uv.x, 2.0) * nn * 3.14 - 3.14 * 0.5));
                float minA = 0.3;// 1;
                float maxA = 0.7;// 9;

                //ここから

                						if (i.uv.x < minA) {

                							xx = xx * pow(i.uv.x / minA, 0.2);

                						}else if (i.uv.x > maxA) {

                							xx = lerp(xx, i.uv.x, pow((i.uv.x - maxA) / (1.0 - maxA), 7.0));

                						}

                						xx += 0.01 * sin(i.uv.y * 2.0 * 3.14);
                						float yy = i.uv.y + 0.05 * sin(i.uv.x * 6.0 * 3.14);

                					    //float ss = strength;
                					    float strength = _strength;
                						float ss = 0.5 + 0.5 * sin(counter * 0.1);
                						ss = ss * strength;
                						xx = lerp(i.uv.x, xx, ss );
                						yy = lerp(i.uv.y, yy, ss );

                						//xx = 0.5+0.5*sin( 2.*3.14*vUv.x -3.14/2.0);

                						//xx = 0.5 + 0.5 * sin(xx * 2.0 * 3.14 * 5.0);
                						//vUv.x

                						float2 axis = float2( xx, yy );


                float rx = pow( 2.0 * abs(i.uv.x - 0.5), 2 );
                float ry = pow( 2.0 * abs(i.uv.y - 0.5), 2 );

                axis.x = lerp(axis.x, i.uv.x, rx);
                axis.y = lerp(axis.y, i.uv.y, ry);

                fixed4 col = tex2D(_MainTex, axis);

                return col;

            }
            ENDCG
        }
    }
    FallBack Off
}