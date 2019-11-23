package com.zaidimarvels.voiceapp;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.speech.tts.TextToSpeech;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.telephony.SmsManager;
import android.text.format.DateUtils;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.Toast;

import java.util.Date;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {
    private static final int MY_PERMISSIONS_REQUEST_RECORD_AUDIO = 1;
    private TextToSpeech tts;
    private SpeechRecognizer speechRecog;
    final int SEND_SMS_PERMISSION_REQUEST_CODE =1;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Here, thisActivity is the current activity
                if (ContextCompat.checkSelfPermission(MainActivity.this,
                        Manifest.permission.RECORD_AUDIO)
                        != PackageManager.PERMISSION_GRANTED) {

                    // Permission is not granted
                    // Should we show an explanation?
                    if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this,
                            Manifest.permission.RECORD_AUDIO)) {
                        // Show an explanation to the user *asynchronously* -- don't block
                        // this thread waiting for the user's response! After the user
                        // sees the explanation, try again to request the permission.
                    } else {
                        // No explanation needed; request the permission
                        ActivityCompat.requestPermissions(MainActivity.this,
                                new String[]{Manifest.permission.RECORD_AUDIO},MY_PERMISSIONS_REQUEST_RECORD_AUDIO);

                        // MY_PERMISSIONS_REQUEST_READ_CONTACTS is an
                        // app-defined int constant. The callback method gets the
                        // result of the request.
                    }
                } else {
                    // Permission has already been granted
                    Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
                    intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
                    intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS,1);
                    speechRecog.startListening(intent);
                }
            }
        });
        
        initializeTextToSpeech();
        initializeSpeechRecognizer();
    }

    private void initializeSpeechRecognizer() {
        if (SpeechRecognizer.isRecognitionAvailable(this)) {
            speechRecog = SpeechRecognizer.createSpeechRecognizer(this);
            speechRecog.setRecognitionListener(new RecognitionListener() {
                @Override
                public void onReadyForSpeech(Bundle params) {

                }

                @Override
                public void onBeginningOfSpeech() {

                }

                @Override
                public void onRmsChanged(float rmsdB) {

                }

                @Override
                public void onBufferReceived(byte[] buffer) {

                }

                @Override
                public void onEndOfSpeech() {

                }

                @Override
                public void onError(int error) {

                }

                @Override
                public void onResults(Bundle results) {
                    List<String> result_arr = results.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
                    processResult(result_arr.get(0));
                }

                @Override
                public void onPartialResults(Bundle partialResults) {

                }

                @Override
                public void onEvent(int eventType, Bundle params) {

                }
            });
        }
    }

    private void processResult(String result_message) {
        result_message = result_message.toLowerCase();

//        Handle at least four sample cases

//        First: What is your Name?
//        Second: What is the time?
//        Third: Is the earth flat or a sphere?
//        Fourth: Open a browser and open url
        //what voice commands
        if(result_message.indexOf("what") != -1){
            if(result_message.indexOf("your name") != -1){
                speak("My Name is Mr. Avon. Nice to meet you Judges!");
            }

            if (result_message.indexOf("time") != -1){
                String time_now = DateUtils.formatDateTime(this, new Date().getTime(),DateUtils.FORMAT_SHOW_TIME);
                speak("The time is now: " + time_now);
            }
        }
        // earth
        else if (result_message.indexOf("earth") != -1){
            speak("Don't be silly, The earth is a sphere. As are all other planets and celestial bodies");
        }
        //tell me jokes
        else if (result_message.indexOf("joke") != -1){
            speak("Tonight I dreamt of a beautiful walk on a sandy beach. At least that explains the footprints I found in the cat litter box this morning. HA HA HA HA");
        }
        //email
        else if (result_message.indexOf("email") != -1){
            speak("Don't be silly, keep driving!");
        }
        //browser
        else if (result_message.indexOf("browser") != -1){
            speak("Opening a browser right away master. Nope, keep driving! ");

        }

        //youtube
        else if (result_message.indexOf("youtube") != -1){
            speak("Did you said Youtube! I ll park the car in the middle of the road and start youtube ? say yes to proceed! OH LORD!");

        }
        //calling
        else if (result_message.indexOf("call ") != -1 ){

            if(result_message.indexOf("mack") != -1){

                Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:9028772889"));
                startActivity(intent);
            }

            if (result_message.indexOf("joy") != -1){

                Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:9028779099"));
                startActivity(intent);


            }
            if (result_message.indexOf("police") != -1){
                speak("Doing it right away master. Nope nope, we don't need police in the event ! HA HA HA ");

            }
            else
            {
                speak("Opening a browser right away master. Nope, keep driving! ");
            }
            System.out.println(result_message);

        }
        //texting
        else if (result_message.indexOf("text") != -1 ){

            if(result_message.indexOf("mark") != -1){
                result_message=result_message.replace("text","");

                result_message=result_message.replace("mark","");

                String text=result_message;

                if (text.length()==0)
                {
                    speak("sir say something , what you want to text! ");
                    System.out.println("send text");
                }

                if(checkPermission(Manifest.permission.SEND_SMS))
                {
                    SmsManager smsManager=SmsManager.getDefault();
                    smsManager.sendTextMessage("9028772889", null, text, null, null);
                    speak("Text send!");
                    System.out.println(" text senndndnnd");


                }

            }

            if (result_message.indexOf("joy") != -1){
                result_message=result_message.replace("text","");

                result_message=result_message.replace("joy","");

                String text=result_message;

                if (text.length()==0)
                {
                    speak("sir say something , what you want to text! ");
                    System.out.println("send text");
                }

                if(checkPermission(Manifest.permission.SEND_SMS))
                {
                    SmsManager smsManager=SmsManager.getDefault();
                    smsManager.sendTextMessage("9028779099", null, text, null, null);
                    speak("Text send!");
                    System.out.println(" text senndndnnd");


                }

            }
            if (result_message.indexOf("police") != -1){
                speak("Doing it right away master. Nope nope, we don't need police in the event ! HA HA HA ");

            }

            System.out.println(result_message);

        }

    }
    public boolean  checkPermission(String perm)
    {
        int check =ContextCompat.checkSelfPermission(this,perm);
        return (check==PackageManager.PERMISSION_GRANTED);
    }
    private void initializeTextToSpeech() {
        tts = new TextToSpeech(this, new TextToSpeech.OnInitListener() {
            @Override
            public void onInit(int status) {
                if (tts.getEngines().size() == 0 ){
                    Toast.makeText(MainActivity.this, getString(R.string.tts_no_engines),Toast.LENGTH_LONG).show();
                    finish();
                } else {
                    tts.setLanguage(Locale.US);
                    speak("Hello Judges, Lets get started! Check Seat Belts for all passengers!");

                }
            }
        });
    }

    private void speak(String message) {
        if(Build.VERSION.SDK_INT >= 21){
            tts.speak(message,TextToSpeech.QUEUE_FLUSH,null,null);
        } else {
            tts.speak(message, TextToSpeech.QUEUE_FLUSH,null);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onPause() {
        super.onPause();
        tts.shutdown();
    }

    @Override
    protected void onResume() {
        super.onResume();
//        Reinitialize the recognizer and tts engines upon resuming from background such as after openning the browser
        initializeSpeechRecognizer();
        initializeTextToSpeech();
    }
}
