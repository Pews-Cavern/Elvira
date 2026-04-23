package com.example.elvira

import android.content.Intent
import android.telecom.Call
import android.telecom.InCallService

class ElviraInCallService : InCallService() {

    private val callbacks = mutableMapOf<Call, Call.Callback>()

    override fun onCallAdded(call: Call) {
        super.onCallAdded(call)
        CallManager.currentCall = call

        val cb = object : Call.Callback() {
            override fun onStateChanged(call: Call, state: Int) {
                CallManager.notify(
                    mapOf(
                        "event" to "stateChanged",
                        "state" to CallManager.stateLabel(state),
                        "name" to CallManager.pendingCallerName,
                        "number" to CallManager.pendingCallerNumber,
                    )
                )
                if (state == Call.STATE_DISCONNECTED || state == Call.STATE_DISCONNECTING) {
                    callbacks.remove(call)?.let { call.unregisterCallback(it) }
                    CallManager.currentCall = null
                }
            }
        }
        callbacks[call] = cb
        call.registerCallback(cb)

        startActivity(
            Intent(this, MainActivity::class.java).apply {
                action = "ELVIRA_CALL_ADDED"
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }
        )

        CallManager.notify(
            mapOf(
                "event" to "callAdded",
                "state" to CallManager.stateLabel(call.state),
                "name" to CallManager.pendingCallerName,
                "number" to CallManager.pendingCallerNumber,
            )
        )
    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
        callbacks.remove(call)?.let { call.unregisterCallback(it) }
        if (CallManager.currentCall == call) CallManager.currentCall = null
        CallManager.notify(mapOf("event" to "callRemoved"))
    }
}
