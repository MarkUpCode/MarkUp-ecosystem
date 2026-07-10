package com.markup.dinerop.notification.template;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class EmailTemplate {

    String title;

    String message;

    String buttonText;

    String buttonUrl;

    String info1;

    String info2;

    String info3;

}