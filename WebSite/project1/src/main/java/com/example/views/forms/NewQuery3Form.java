package com.example.views.forms;

import com.example.services.Services;
import com.example.views.NewQueries2;
import com.example.views.NewQueries3;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.textfield.TextField;

public class NewQuery3Form extends FormLayout {
    private final TextField giroName = new TextField("Nombre del Giro");
    private final TextField year = new TextField("Año");
    private final Button call = new Button("Update");

    private final Services service;

    private final NewQueries3 newQueries;

    public NewQuery3Form(Services service, NewQueries3 newQueries){
        this.service = service;
        this.newQueries = newQueries;

        setSizeUndefined();
        setVisible(false);
        configureUpdate();

        HorizontalLayout horizontalLayout = new HorizontalLayout(call);
        add(giroName, year, horizontalLayout);
    }

    public void configureUpdate(){
        call.addClickListener(buttonClickEvent -> newQueries.updateDataGrid(service.getNewQuery3(giroName.getValue(), year.getValue())));
    }
}
