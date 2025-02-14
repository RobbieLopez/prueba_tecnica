<?php

namespace App\Http\Controllers;

use App\DTOs\JobDTO;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class JobController extends Controller
{
    public function create(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'location' => 'nullable|string|max:150',
            'salary' => 'nullable|numeric',
        ]);

        $jobDTO = new JobDTO($validated);

        DB::statement('CALL CreateJob(:title, :description, :location, :salary)', [
            $jobDTO->title,
            $jobDTO->description,
            $jobDTO->location,
            $jobDTO->salary
        ]);

        return response()->json(['message' => 'Job created successfully'], 201);
    }

    public function index()
    {
        $jobs = DB::select('CALL GetAllJobs()');
        return response()->json($jobs, 200);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'location' => 'nullable|string|max:150',
            'salary' => 'nullable|numeric',
        ]);

        $jobDTO = new JobDTO($validated);

        DB::statement('CALL UpdateJob(:id, :title, :description, :location, :salary)', [
            $id, 
            $jobDTO->title,
            $jobDTO->description,
            $jobDTO->location,
            $jobDTO->salary
        ]);

        return response()->json(['message' => 'Job updated successfully']);
    }
}