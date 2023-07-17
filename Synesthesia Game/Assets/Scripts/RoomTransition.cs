using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomTransition : MonoBehaviour
{

    //Reference to transiton rooms
    public GameObject RoomPrev;
    public GameObject RoomNext;

    //Reference to Virtual Cameras
    private GameObject virtualCamPrev;
    private GameObject virtualCamNext;


    //Reference to MoveOnFlag
    private RoomManager RoomManagerPrev;
    private RoomManager RoomManagerNext;

    private bool StartNextRoom, StartPrevRoom;
    // Start is called before the first frame update
    void Start()
    {
        RoomManagerPrev = RoomPrev.GetComponent<RoomManager>();
        RoomManagerNext = RoomNext.GetComponent<RoomManager>();
        StartNextRoom = false;
        StartPrevRoom = false;
    }


    void Update(){
        if(StartNextRoom){
            if(!RoomManagerPrev.isMusicLogicActive()){
                RoomManagerNext.continueSongEnter();
                StartNextRoom = false;                
            }
        }
        if(StartPrevRoom){
            if(!RoomManagerNext.isMusicLogicActive()){
                RoomManagerPrev.continueSongEnter();
                StartPrevRoom = false;
            }
        }
    }
    // Update is called once per frame
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player") && other.isTrigger){
        //Move to next room
            if (!RoomManagerNext.isMusicLogicActive())
            {
                RoomManagerPrev.continueSongLeave();

                StartNextRoom = true;
            }
            //Move to prev room
            else{
                RoomManagerNext.continueSongLeave();

                StartPrevRoom = true;

            }
        }
    }
    private void OnTriggerExit2D(Collider2D other)
    {

    }
}
