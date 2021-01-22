package com.example.views;

import com.example.pojos.Query1;
import com.example.pojos.Query3;
import com.example.services.Services;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.grid.GridVariant;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

@Route(value = "advancedQueries")
@CssImport("./styles/shared-styles.css")
public class AdvancedQueries extends VerticalLayout {
    private final Services services;

    private final Grid<Query1> dataGridQueryOne = new Grid<>(Query1.class);
    private final Grid<Query3> dataGridQueryThree = new Grid<>(Query3.class);

    private final Button getQuery1 = new Button("Get Query One");
    private final Button getQuery3 = new Button("Get Query Three");

    public AdvancedQueries(@Autowired Services services) {
        this.services = services;

        H1 h1 = new H1("Advanced Queries");
        HorizontalLayout horizontalLayout = new HorizontalLayout();

        configureButtonOne();
        configureButtonThree();

        horizontalLayout.add(getQuery1, getQuery3);

        HorizontalLayout gridLayout = new HorizontalLayout();
        gridLayout.setSizeFull();

        dataGridQueryOne.setVisible(false);
        dataGridQueryThree.setVisible(false);
        gridLayout.add(dataGridQueryOne, dataGridQueryThree);

        add(h1, horizontalLayout, gridLayout);
    }

    public void configureButtonOne(){

        getQuery1.addClickListener(buttonClickEvent -> {
            dataGridQueryThree.setVisible(false);
            dataGridQueryOne.setVisible(true);
            dataGridQueryOne.setItems(services.getQueryOne());
        });

    }

    public void configureButtonThree(){
        getQuery3.addClickListener(buttonClickEvent -> {
            dataGridQueryOne.setVisible(false);
            dataGridQueryThree.setVisible(true);
            dataGridQueryThree.setItems(services.getQueryThree());
        });
    }

    public void configureDataGridQueryOne(){
        dataGridQueryOne.setVisible(false);
        dataGridQueryOne.setSizeFull();
        dataGridQueryOne.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGridQueryOne.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGridQueryOne.setVerticalScrollingEnabled(true);
        dataGridQueryOne.getColumns().forEach(col -> col.setAutoWidth(true));
    }

    public void configureDataGridQueryThree(){
        dataGridQueryThree.setVisible(false);
        dataGridQueryThree.setSizeFull();
        dataGridQueryThree.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGridQueryThree.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGridQueryThree.setVerticalScrollingEnabled(true);
        dataGridQueryThree.getColumns().forEach(col -> col.setAutoWidth(true));
    }


}
