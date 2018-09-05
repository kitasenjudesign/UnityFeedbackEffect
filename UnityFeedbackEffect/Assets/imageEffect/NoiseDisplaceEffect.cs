
using UnityEngine;

public class NoiseDisplaceEffect : CustomImageEffect
{
    #region Fields

    //明るさをいじれるように


    [SerializeField] [Range(0, 1)] public float rate = 1f;
    [SerializeField] [Range(0, 1000)] public float frame = 1f;
    [SerializeField] public Vector2 faceCenter;
    [SerializeField] [Range(0, 1)] public float faceRadius = 1f;
    [SerializeField] [Range(0, 1)] public float waveForce = 1f;
    [SerializeField] public Vector2 noiseDetail;
    //private Tween _twn;


    /*
    [SerializeField] [Range(0, 1)] private float rate = 1f;
    [SerializeField] [Range(0, 1)] private float rate = 1f;
    [SerializeField] [Range(0, 1)] private float rate = 1f;
    [SerializeField] [Range(0, 1)] private float rate = 1f;
    [SerializeField] [Range(0, 1)] private float rate = 1f;
    */
    #endregion

    #region Properties

    public override string ShaderName
    {
        get { return "CustomImageEffect/NoiseDisplacement"; }
    }

    #endregion

    #region Methods


    public void TweenRate(float tgtRate,float time,float delay)
    {
        //if(_twn != null) _twn.Kill();
       // _twn = DOTween.To(() => rate, (x) => rate = x, tgtRate, time).SetEase(Ease.OutSine).SetDelay(delay);
    }
    
    
    public override void UpdateMaterial()
    {
        /*
        float rate;
        float frame;
        float2 faceCenter;
        float faceRadius;
        float waveForce;
        */

        frame += Time.deltaTime * 40f;
        noiseDetail.x = 1f + 1f * Mathf.Sin(frame * 0.073f);
        noiseDetail.y = 0.5f + 0.5f * Mathf.Cos(frame * 0.043f);
        
        

        Material.SetFloat("rate",rate);
        Material.SetFloat("frame",frame);

        Material.SetVector("faceCenter",faceCenter);
        Material.SetVector("noiseDetail",noiseDetail);

        Material.SetFloat("faceRadius",faceRadius);
        Material.SetFloat("waveForce",waveForce);

        //Material.SetFloat("_Brightness", m_Brightness);
    }

    #endregion

}