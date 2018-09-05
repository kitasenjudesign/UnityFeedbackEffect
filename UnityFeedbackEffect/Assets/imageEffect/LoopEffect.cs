using UnityEngine;

public class LoopEffect : CustomImageEffect
{
    #region Fields

    //明るさをいじれるように
    [SerializeField] [Range(0, 100)] private float counter = 1f;
    [SerializeField] [Range(0, 3)] public float strength = 1f;

    #endregion

    #region Properties

    public override string ShaderName
    {
        get { return "CustomImageEffect/Loop"; }
    }

    #endregion

    #region Methods

    public override void UpdateMaterial()
    {
        //Material.SetFloat("_Brightness", m_Brightness);
        counter += 0.1f;
        Material.SetFloat("_counter", counter);
        Material.SetFloat("_strength", strength);
    }

    #endregion

}