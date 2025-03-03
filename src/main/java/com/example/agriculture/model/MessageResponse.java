package com.example.agriculture.model;

import lombok.Data;

@Data
public class MessageResponse {
        private Messag messag;

        public MessageResponse(Messag messag) {
            this.messag = messag;
        }

        public Messag getMessag() {
            return messag;
        }

        public void setMessag(Messag messag) {
            this.messag = messag;
        }
}
