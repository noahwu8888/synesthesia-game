using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomManager : MonoBehaviour
{
    public int roomNumber;
    public GameObject virtualCam;
    public GameObject MusicLogic;
    public int roomNumber;
    private MusicBarScript MusicBar;

    public bool TurnOffCameraFlag;

    private void Start()
    {
        MusicBar = GetComponentInChildren<MusicBarScript>(true);
        //MusicBar = MusicLogic.transform.GetChild(2).gameObject.GetComponent<MusicBarScript>();

    }
    private void Update()
    {
        //Looks for Turn Off Camera Flag, if true, disable camera once music loop reaches end, then set false.
        if (MusicBar.TurnOffCameraFlag)
        {
            virtualCam.SetActive(false);
            MusicBar.TurnOffCameraFlag = false;
        }
    }

    public bool isMusicLogicActive()
    {
        return MusicLogic.activeSelf;
    }

    public void continueSongLeave()
    {
        MusicBar.ContinueSongFlag = true;
        //virtualCam.SetActive(false);
    }

    public void continueSongEnter()
    {
        MusicBar.ContinueSongFlag = false;

        MusicLogic.SetActive(true);


        virtualCam.SetActive(true);

    }


    /*private void OnTriggerStay2D(Collider2D other)
    {
        if (other.CompareTag("Player") && other.isTrigger)
        {
            MusicLogic.SetActive(true);
            virtualCam.SetActive(true);
        }
    }
    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player") && other.isTrigger)
        {
            MusicLogic.SetActive(false);
            virtualCam.SetActive(false);
        }
    }*/
}