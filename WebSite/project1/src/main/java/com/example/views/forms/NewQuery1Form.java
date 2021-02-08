package com.example.views.forms;

import com.example.services.Services;
import com.example.views.NewQueries;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.textfield.TextField;

public class NewQuery1Form extends FormLayout {
    private final TextField giroName = new TextField("Nombre del Giro");
    private final TextField year = new TextField("Año");
    private final Button call = new Button("Update");

    private final Services service;

    private final NewQueries newQueries;

    public NewQuery1Form(Services service, NewQueries newQueries){
        this.service = service;
        this.newQueries = newQueries;

        setSizeUndefined();
        setVisible(false);
        configureUpdate();

        HorizontalLayout horizontalLayout = new HorizontalLayout(call);
        add(giroName, year, horizontalLayout);
    }

    public void configureUpdate(){
        call.addClickListener(buttonClickEvent -> newQueries.updateDataGrid(service.getNewQuery1(giroName.getValue(), year.getValue())));
    }
}
