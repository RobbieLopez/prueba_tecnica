<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\DTOs\ApplicationDTO;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ApplicationController extends Controller
{
    public function create(Request $request)
    {
        $validated = $request->validate([
            'candidateId' => 'required|integer',
            'jobId' => 'required|integer',
        ]);

        DB::statement('CALL ApplyToJob(?, ?)', [
            $validated['candidateId'],
            $validated['jobId'],
        ]);

        return response()->json(['message' => 'Application submitted successfully'], 201);
    }

    public function index()
    {
        $applications = DB::select('CALL GetAllApplications()');
        return response()->json($applications, 200);
    }

    public function updateStatus(Request $request, $id)
    {
        $validated = $request->validate([
            'statusId' => 'required|integer|in:1,2,3,4',  
        ]);

        DB::statement('CALL UpdateApplicationStatus(?, ?)', [
            $id, 
            $validated['statusId']
        ]);

        return response()->json(['message' => 'Application status updated successfully']);
    }
}