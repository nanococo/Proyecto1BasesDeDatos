package com.example.views;

import com.example.pojos.Movement;
import com.example.services.Services;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.grid.GridVariant;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import org.springframework.beans.factory.annotation.Autowired;

public class ObjectiveAccountsView extends VerticalLayout {

    private final Grid<Movement> dataGrid = new Grid<>(Movement.class);

    private final Services services;

//    private final Button viewMovements = new Button("Movimientos");

    public ObjectiveAccountsView(@Autowired Services services) {
        this.services = services;

        H1 h1 = new H1("Cuentas Objetivo");
        configureDataGrid();
        setSizeFull();
        add(h1, dataGrid);
    }


    private void configureDataGrid() {
        dataGrid.setItems(services.getMovements());
        dataGrid.setSizeFull();
        dataGrid.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGrid.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGrid.setVerticalScrollingEnabled(true);
        //dataGrid.setColumnOrder(dataGrid.getColumnByKey("statementId"), dataGrid.getColumnByKey("accountId"), dataGrid.getColumnByKey("initialBalance"), dataGrid.getColumnByKey("endBalance"), dataGrid.getColumnByKey("startDate"), dataGrid.getColumnByKey("endDate"));
        dataGrid.getColumns().forEach(col -> col.setAutoWidth(true));
        dataGrid.asSingleSelect().addValueChangeListener(event -> {
//            Common.startDate = event.getValue().getStartDate();
//            Common.endDate = event.getValue().getEndDate();
//            viewMovements.setEnabled(true);
        });
    }

}
