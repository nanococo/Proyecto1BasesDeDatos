package com.example.views;

import com.example.pojos.NewQuery4;
import com.example.services.Services;
import com.example.views.forms.NewQuery4Form;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.grid.GridVariant;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;

@Route(value = "newQuery4")
@CssImport("./styles/shared-styles.css")
public class NewQueries4 extends VerticalLayout {
    private final Services services;

    private final Grid<NewQuery4> dataGridQueryOne = new Grid<>(NewQuery4.class);

    private final NewQuery4Form newQuery1Form;


    private final Button getQuery1 = new Button("Show");

    public NewQueries4(@Autowired Services services) {
        this.services = services;
        this.newQuery1Form = new NewQuery4Form(services, this);

        H1 h1 = new H1("Top 3 Equipos del Giro");
        HorizontalLayout horizontalLayout = new HorizontalLayout();

        configureButtonOne();

        horizontalLayout.add(getQuery1);

        HorizontalLayout gridLayout = new HorizontalLayout();
        gridLayout.setSizeFull();

        dataGridQueryOne.setVisible(false);
        gridLayout.add(dataGridQueryOne, newQuery1Form);

        add(h1, horizontalLayout, gridLayout);
    }

    public void configureButtonOne(){

        getQuery1.addClickListener(buttonClickEvent -> {
            dataGridQueryOne.setVisible(true);
            newQuery1Form.setVisible(true);
            //dataGridQueryOne.setItems(services.getQueryOne());
        });

    }

    public void updateDataGrid(ArrayList<NewQuery4> data){
        dataGridQueryOne.setItems(data);
    }


    public void configureDataGridQueryOne(){
        dataGridQueryOne.setVisible(false);
        dataGridQueryOne.setSizeFull();
        dataGridQueryOne.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGridQueryOne.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGridQueryOne.setVerticalScrollingEnabled(true);
        dataGridQueryOne.getColumns().forEach(col -> col.setAutoWidth(true));
    }


}
