using UnityEngine;
using UnityEditor;

public class TopoShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // Find properties by name
        MaterialProperty minY = FindProperty("_MinY", properties);
        MaterialProperty maxY = FindProperty("_MaxY", properties);
        MaterialProperty rampTex = FindProperty("_RampTex", properties);
        MaterialProperty bandCnt = FindProperty("_BandCnt", properties);
        MaterialProperty bandCntMin = FindProperty("_BandCntMin", properties);
        MaterialProperty bandCntMax = FindProperty("_BandCntMax", properties);

        // These are properties that can just use default UI for corresponding types
        materialEditor.ShaderProperty(minY, minY.displayName);
        materialEditor.ShaderProperty(maxY, maxY.displayName);
        materialEditor.ShaderProperty(rampTex, rampTex.displayName);

        // This is the int slider
        int bandValue = Mathf.RoundToInt(bandCnt.floatValue);
        int bandMinVal = Mathf.RoundToInt(bandCntMin.floatValue);
        int bandMaxVal = Mathf.RoundToInt(bandCntMax.floatValue);
        int newBandValue = EditorGUILayout.IntSlider(bandCnt.displayName, bandValue, bandMinVal, bandMaxVal);
        if (newBandValue != bandValue)
        {
            bandCnt.floatValue = newBandValue;
        }
        
        materialEditor.ShaderProperty(bandCntMin, bandCntMin.displayName);
        materialEditor.ShaderProperty(bandCntMax, bandCntMax.displayName);
    }
}
