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
    [SerializeField] private float barSpeed;
    private Vector3 startPos;
    private Vector3 endPos;

    [SerializeField] private float elapsedTime;
    #endregion
    private void Start()
    {
        startPos = _startPos.transform.position;
        endPos = _endPos.transform.position;
        transform.position = startPos;
        //Calucluates how long the bar should take to reach _endPos
        barSpeed = ((_beatsPerMinute / 60f) * _timeSignature * (_measuresNum - 1)) + ((_beatsPerMinute / 60f)/(_beatsPerMeasure*2));
    }
    // Update is called once per frame
    void Update()
    {
        elapsedTime += Time.deltaTime;

        float percentToEnd = elapsedTime / barSpeed;

        transform.position = Vector3.Lerp(startPos, endPos, percentToEnd);
        if (transform.position.x == endPos.x)
        {
            transform.position = startPos;
            elapsedTime = 0;
        }
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if (other.gameObject.tag == "Music Logic")
        {
            Debug.Log("Collision hit");
            _audioSource.transform.position = new Vector3(transform.position.x, other.transform.position.y, 0);
        }

    }
}
