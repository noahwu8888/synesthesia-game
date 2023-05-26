using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomManager : MonoBehaviour
{
    public GameObject virtualCam;
    public GameObject MusicLogic;
    private MusicBarScript MusicBar;

    private void Start()
    {
        MusicBar = MusicLogic.transform.GetChild(2).gameObject.GetComponent<MusicBarScript>();

    }

    public bool isMusicLogicActive()
    {
        return MusicLogic.activeSelf;
    }

    public void continueSongLeave()
    {
        MusicBar.ContinueSongFlag = true;
        virtualCam.SetActive(false);
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