using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicBarScript : MonoBehaviour
{
    #region References
    [Header("References")]
    public GameObject _startPos;
    public GameObject _endPos;

    public GameObject _audioSource;

    #endregion


    #region Bar Movement
    [Header("Bar Movement")]
    public float _beatsPerMinute;
    public float _timeSignature = 4 / 4;
    public float _measuresNum;
    public float _beatsPerMeasure;
    [SerializeField] public float barSpeed;
    public float percentToEnd;
    private Vector3 startPos;
    private Vector3 endPos;

    //Used in other scripts
    //Should the music end and move on?
    public bool ContinueSongFlag;
    //Should the camera of the room turn off?
    public bool TurnOffCameraFlag;
    [SerializeField] private float elapsedTime;
    #endregion
    private void Start()
    {
        startPos = _startPos.transform.position;
        endPos = _endPos.transform.position;
        transform.position = startPos;
        ContinueSongFlag = false;
        TurnOffCameraFlag = false;
        //Calucluates how long the bar should take to reach _endPos
        barSpeed = ((60f / _beatsPerMinute) * _beatsPerMeasure * (_measuresNum));
    }
    // Update is called once per frame
    void Update()
    {
        // elapsed time counts up
        elapsedTime += Time.deltaTime;

        //calculate lerp percent
        percentToEnd = elapsedTime / barSpeed;
        //lerp bar
        transform.position = Vector3.Lerp(startPos, endPos, percentToEnd);
        //if reach end: restart bar
        if (transform.position.x == endPos.x)
        {
            transform.position = startPos;
            elapsedTime = 0;
            if (ContinueSongFlag)
            {
                ContinueSongFlag = false;
                TurnOffCameraFlag = true;
                transform.parent.gameObject.SetActive(false);
            }
        }
    }

    // if hit a sound source, play sound at that location
    private void OnTriggerStay2D(Collider2D other)
    {
        if (other.gameObject.tag == "Music Logic")
        {
            AudioEmitter.instance.transform.position = new Vector3(transform.position.x, other.transform.position.y, 0);
        }

    }
}
