using UnityEngine;

public class GrayImageEffect : CustomImageEffect
{
    #region Fields

    //明るさをいじれるように
    [SerializeField] [Range(0, 3)] private float m_Brightness = 1f;

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
        Material.SetFloat("_Brightness", m_Brightness);
    }

    #endregion

}