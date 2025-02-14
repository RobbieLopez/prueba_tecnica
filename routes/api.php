<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CandidateController;
use App\Http\Controllers\JobController;
use App\Http\Controllers\ApplicationController;

// Rutas para candidatos
Route::post('/candidates', [CandidateController::class, 'create']);
Route::put('/candidates/{id}', [CandidateController::class, 'update']);
Route::post('/candidates/delete', [CandidateController::class, 'delete']);
Route::get('/candidates', [CandidateController::class, 'index']); 

// Rutas para puestos
Route::post('/jobs', [JobController::class, 'create']);
Route::put('/jobs/{id}', [JobController::class, 'update']);
Route::get('/jobs', [JobController::class, 'index']); 

// Rutas para aplicaciones a puestos
Route::post('/applications', [ApplicationController::class, 'create']); 
Route::put('/applications/{id}', [ApplicationController::class, 'updateStatus']); 
Route::get('/applications', [ApplicationController::class, 'index']);
